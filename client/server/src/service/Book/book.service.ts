import Database from "@src/DB/DB";
import { IBook } from "@src/dto/book/book.dto";
import { IError } from "@src/dto/error.dto";
import * as OracleDB from "oracledb";

class BookService {
	constructor() {}

	async searchBook(searchTerms: string): Promise<IError<IBook>> {
		let result: IError<IBook>;

		const connection = await Database.getConnection();

		const query: OracleDB.Result<IBook> = await connection.execute(
			`SELECT * from  TABLE(search_books(:searchTerms))`,
			[searchTerms],
			{ outFormat: OracleDB.OUT_FORMAT_OBJECT }
		);

		if (!query.rows || query.rows.length <= 0) {
			return (result = {
				message: "Книги не найдены",
				code: 200,
				data: query.rows,
			});
		}

		return (result = {
			message: "Найденные книги по вашему запросу",
			code: 200,
			data: query.rows,
		});
	}

	createBook = async (book: IBook): Promise<IError<IBook>> => {
		let result: IError<IBook>;
		const connection = await Database.getConnection();

		const isTitleUsed = await connection.execute(
			`
			SELECT * FROM Book WHERE title = :title
			`,
			[book.title],
			{
				outFormat: OracleDB.OUT_FORMAT_OBJECT,
			}
		);

		if (isTitleUsed && isTitleUsed.rows && isTitleUsed.rows.length > 0) {
			return (result = {
				message: "Книга с такими именем уже существует",
				code: 400,
				data: null,
			});
		}

		const isIsbnUser = await connection.execute(
			`
				SELECT * FROM Book WHERE isbn = :isbn
				`,
			[book.isbn],
			{
				outFormat: OracleDB.OUT_FORMAT_OBJECT,
			}
		);

		if (isIsbnUser && isIsbnUser.rows && isIsbnUser.rows.length > 0) {
			return (result = {
				message: "Книга с такими isbn уже существует",
				code: 400,
				data: null,
			});
		}

		console.log(book.publication_date);

		console.log(book.coverName);

		await connection.execute(
			`DECLARE
				BEGIN
						create_book(
						   :p_title,
						   :p_description,
						   :p_publication_date,
						   :p_publisher_name,
						   :p_isbn,
						   :p_tags,
						   :p_num_pages,
						   :p_copies,
						   :p_file_name,
						   :p_image_name
						);
					   END;`,
			{
				p_title: book.title,
				p_description: book.description,
				p_publication_date: book.publication_date,
				p_publisher_name: book.publisher_name,
				p_isbn: book.isbn,
				p_tags: book.tags,
				p_num_pages: { val: book.num_pages },
				p_copies: { val: book.copies },
				p_file_name: book.pdfName,
				p_image_name: book.coverName,
			}
		);

		const titleBook: OracleDB.Result<string> = await connection.execute(
			`SELECT title FROM Book WHERE title = :title`,
			[book.title],
			{
				outFormat: OracleDB.OUT_FORMAT_OBJECT,
			}
		);

		return (result = {
			message: "Книга созданаы",
			code: 200,
			data: book,
		});
	};

	getBookById = async (id: string): Promise<IError<IBook>> => {
		let result: IError<IBook>;

		const connection = await Database.getConnection();

		const query: OracleDB.Result<IBook> = await connection.execute(
			`SELECT * from  TABLE(get_book_by_id(:id))`,
			[id],
			{ outFormat: OracleDB.OUT_FORMAT_OBJECT }
		);

		if (!query.rows || query.rows.length <= 0) {
			return (result = {
				message: "Книга не найдена",
				code: 400,
				data: null,
			});
		}

		return (result = {
			message: "Книга найдена",
			code: 200,
			data: query.rows[0],
		});
	};

	getBookByAuthor = async (
		id: string,
		page_number: number,
		page_size: number
	): Promise<IError<IBook>> => {
		let result: IError<IBook>;

		const connection = await Database.getConnection();

		const query: OracleDB.Result<IBook> = await connection.execute(
			`SELECT * from  TABLE(get_books_by_author(:id, :p_page_number, :p_page_size))`,
			{
				id,
				p_page_number: {
					val: page_number,
					type: OracleDB.NUMBER,
				},
				p_page_size: { val: page_size, type: OracleDB.NUMBER },
			},
			{ outFormat: OracleDB.OUT_FORMAT_OBJECT }
		);

		if (!query.rows || query.rows.length <= 0) {
			return (result = {
				message: "Книга автора не найдены",
				code: 400,
				data: null,
			});
		}

		return (result = {
			message: "Книги автора",
			code: 200,
			data: query.rows,
		});
	};

	getBookByCategory = async (
		id: string,
		page_number: number,
		page_size: number
	): Promise<IError<IBook>> => {
		let result: IError<IBook>;

		const connection = await Database.getConnection();

		const query: OracleDB.Result<IBook> = await connection.execute(
			`SELECT * from TABLE(get_books_by_category(:id, :p_page_number, :p_page_size))`,
			{
				id,
				p_page_number: {
					val: page_number,
					type: OracleDB.NUMBER,
				},
				p_page_size: { val: page_size, type: OracleDB.NUMBER },
			},
			{ outFormat: OracleDB.OUT_FORMAT_OBJECT }
		);

		if (!query.rows || query.rows.length <= 0) {
			return (result = {
				message: "Книги выбранной категории не найдены",
				code: 400,
				data: null,
			});
		}

		return (result = {
			message: "Книги автора",
			code: 200,
			data: query.rows,
		});
	};

	getBookByPublisher = async (
		id: string,
		page_number: number,
		page_size: number
	): Promise<IError<IBook>> => {
		let result: IError<IBook>;

		const connection = await Database.getConnection();

		const query: OracleDB.Result<IBook> = await connection.execute(
			`SELECT * from TABLE(get_books_by_publisher(:id, :p_page_number, :p_page_size))`,
			{
				id,
				p_page_number: {
					val: page_number,
					type: OracleDB.NUMBER,
				},
				p_page_size: { val: page_size, type: OracleDB.NUMBER },
			},
			{ outFormat: OracleDB.OUT_FORMAT_OBJECT }
		);

		if (!query.rows || query.rows.length <= 0) {
			return (result = {
				message: "Книги выбранной категории не найдены",
				code: 400,
				data: null,
			});
		}

		return (result = {
			message: "Книги автора",
			code: 200,
			data: query.rows,
		});
	};

	getAllBooks = async (
		page_number: number,
		page_size: number
	): Promise<IError<IBook>> => {
		let result: IError<IBook>;

		const connection = await Database.getConnection();

		const query: OracleDB.Result<IBook> = await connection.execute(
			`SELECT * from TABLE(get_all_books(:p_page_number, :p_page_size))`,
			{
				p_page_number: {
					val: page_number,
					type: OracleDB.NUMBER,
				},
				p_page_size: { val: page_size, type: OracleDB.NUMBER },
			},
			{ outFormat: OracleDB.OUT_FORMAT_OBJECT }
		);

		if (!query.rows || query.rows.length <= 0) {
			return (result = {
				message: "Книги выбранной категории не найдены",
				code: 400,
				data: null,
			});
		}

		return (result = {
			message: "Список всех книг",
			code: 200,
			data: query.rows,
		});
	};

	deleteBook = async (id: string): Promise<IError<IBook>> => {
		let result: IError<IBook>;

		const connection = await Database.getConnection();

		const isSelect: OracleDB.Result<IBook> = await connection.execute(
			`SELECT * FROM TABLE(get_book_by_id(:id))`,
			[id],
			{ outFormat: OracleDB.OUT_FORMAT_OBJECT }
		);

		if (!isSelect.rows || isSelect.rows.length <= 0) {
			return (result = {
				message: "Book not found :D",
				code: 400,
				data: null,
			});
		}

		await connection.execute(
			`BEGIN
				delete_book_set_null(
					:id
				);
			END;`,
			[id]
		);

		return (result = {
			message: "Книги удалена",
			code: 200,
			data: isSelect.rows[0],
		});
	};

	updateBook = async (id: string, book: IBook): Promise<IError<IBook>> => {
		let result: IError<IBook>;
		const connection = await Database.getConnection();

		const isTitleUsed = await connection.execute(
			`
			SELECT * FROM Book WHERE title = :title
			`,
			[book.title],
			{
				outFormat: OracleDB.OUT_FORMAT_OBJECT,
			}
		);

		if (isTitleUsed && isTitleUsed.rows && isTitleUsed.rows.length > 0) {
			return (result = {
				message: "Книга с такими именем уже существует",
				code: 400,
				data: null,
			});
		}

		await connection.execute(
			`BEGIN
					update_book(
						:p_book_id,
						:p_title,
						:p_description,
						:p_publication_date,
						:p_publisher_name,
						:p_isbn,
						:p_tags,
						:p_copies,
						:p_num_pages,
						:p_file_name,
						:p_image_name
					);
			END;`,
			{
				p_book_id: id,
				p_title: book.title,
				p_description: book.description,
				p_publication_date: book.publication_date,
				p_publisher_name: book.publisher_name,
				p_isbn: book.isbn,
				p_tags: book.tags,
				p_copies: book.copies,
				p_num_pages: book.num_pages,
				p_file_name: book.pdfName,
				p_image_name: book.coverName,
			}
		);

		return (result = {
			message: "Книга обновлена",
			code: 200,
			data: null,
		});
	};
}

export default BookService;
