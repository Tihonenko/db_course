import Database from "@src/DB/DB";
import { IAuthor } from "@src/dto/author/author.dto";
import { IError } from "@src/dto/error.dto";
import { IOrder } from "@src/dto/order/order.dto";
import Email from "@src/email/Email";
import OracleDB from "oracledb";

export class AuthorService {
	constructor() {}

	createAuthor = async (author: IAuthor): Promise<IError<IAuthor>> => {
		let result: IError<IAuthor>;

		const email = new Email();

		const connection = await Database.getConnection();
		const query: OracleDB.Result<IAuthor> = await connection.execute(
			`BEGIN
				   create_author(:name);
				 END;`,
			{ name: author.name }
		);

		return (result = {
			message: "Автор создан всех книг",
			code: 200,
			data: query.rows,
		});
	};

	getAllAuthors = async (): Promise<IError<IAuthor>> => {
		let result: IError<IAuthor>;

		const connection = await Database.getConnection();

		const query: OracleDB.Result<IAuthor> = await connection.execute(
			`SELECT * from TABLE(get_all_authors())`,
			{},
			{ outFormat: OracleDB.OUT_FORMAT_OBJECT }
		);

		if (!query.rows || query.rows.length <= 0) {
			return (result = {
				message: "Книги выбранного автора не найдены",
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

	deleteAuthor = async (id: string): Promise<IError<IAuthor>> => {
		let result: IError<IAuthor>;

		const connection = await Database.getConnection();

		const query: OracleDB.Result<IAuthor> = await connection.execute(
			`BEGIN
                delete_author_set_null(:p_author_id);
            END;`,
			{
				p_author_id: { val: id, type: OracleDB.DB_TYPE_NVARCHAR },
			}
		);

		return (result = {
			code: 200,
			message: "Автор удален",
		});
	};

	authorBook = async (
		book_id: string,
		author_id: string
	): Promise<IError<IAuthor>> => {
		let result: IError<IAuthor>;

		const connection = await Database.getConnection();

		const isBook = await connection.execute(
			`
			    SELECT * FROM Book WHERE book_id = :book_id
			`,
			[book_id],
			{
				outFormat: OracleDB.OUT_FORMAT_OBJECT,
			}
		);

		if (!isBook.rows || isBook.rows.length <= 0) {
			return (result = {
				message: "Книга не найдена:D",
				code: 400,
				data: null,
			});
		}

		const isAuthor = await connection.execute(
			`
			    SELECT * FROM Author WHERE author_id = :author_id
			`,
			[author_id],
			{
				outFormat: OracleDB.OUT_FORMAT_OBJECT,
			}
		);

		if (!isAuthor.rows || isAuthor.rows.length <= 0) {
			return (result = {
				message: "Этого автора нету :D",
				code: 400,
				data: null,
			});
		}

		const query: OracleDB.Result<IAuthor> = await connection.execute(
			`BEGIN
                link_book_author(:p_book_id, :p_author_id);
            END;`,
			{
				p_book_id: { val: book_id, type: OracleDB.DB_TYPE_NVARCHAR },
				p_author_id: { val: author_id, type: OracleDB.DB_TYPE_NVARCHAR },
			}
		);

		return (result = {
			code: 200,
			message: "Автор добавлен в книгу",
		});
	};

	updateAuthor = async (id: string, name: string): Promise<IError<IAuthor>> => {
		let result: IError<IAuthor>;

		const connection = await Database.getConnection();

		await connection.execute(
			`BEGIN
				update_author(:p_category_id, :p_name);
			END;`,
			{
				p_category_id: id,
				p_name: name,
			}
		);

		return (result = {
			message: "Автор обновлена",
			code: 200,
			data: null,
		});
	};
}

export default AuthorService;
