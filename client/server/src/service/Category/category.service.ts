import Database from '@src/DB/DB';
import { IAuthor } from '@src/dto/author/author.dto';
import { ICategory } from '@src/dto/category/category.dto';
import { IError } from '@src/dto/error.dto';
import { IOrder } from '@src/dto/order/order.dto';
import Email from '@src/email/Email';
import OracleDB from 'oracledb';

export class CategoryService {
	constructor() {}

	createCategory = async (
		category: ICategory
	): Promise<IError<ICategory>> => {
		let result: IError<ICategory>;

		const email = new Email();

		const connection = await Database.getConnection();
		const query: OracleDB.Result<ICategory> = await connection.execute(
			`BEGIN
				   create_category(:name);
			END;`,
			{ name: category.name }
		);

		return (result = {
			message: 'Category created',
			code: 200,
			data: query.rows,
		});
	};

	getAllCategories = async (): Promise<IError<ICategory>> => {
		let result: IError<ICategory>;

		const connection = await Database.getConnection();

		const query: OracleDB.Result<ICategory> = await connection.execute(
			`SELECT * from TABLE(get_all_categories())`,
			{},
			{ outFormat: OracleDB.OUT_FORMAT_OBJECT }
		);

		if (!query.rows || query.rows.length <= 0) {
			return (result = {
				message: 'Книги выбранного автора не найдены',
				code: 400,
				data: null,
			});
		}

		return (result = {
			message: 'Книги автора',
			code: 200,
			data: query.rows,
		});
	};

	deleteCategory = async (id: string): Promise<IError<ICategory>> => {
		let result: IError<ICategory>;

		const connection = await Database.getConnection();

		const query: OracleDB.Result<ICategory> = await connection.execute(
			`BEGIN
                delete_category_set_null(:p_category_id);
            END;`,
			{
				p_category_id: { val: id, type: OracleDB.DB_TYPE_NVARCHAR },
			}
		);

		return (result = {
			code: 200,
			message: 'Category deleted',
		});
	};

	categoryBook = async (
		book_id: string,
		category_id: string
	): Promise<IError<ICategory>> => {
		let result: IError<ICategory>;

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
				message: 'Book not found:D',
				code: 400,
				data: null,
			});
		}

		const isAuthor = await connection.execute(
			`
			    SELECT * FROM Category WHERE category_id = :category_id
			`,
			[category_id],
			{
				outFormat: OracleDB.OUT_FORMAT_OBJECT,
			}
		);

		if (!isAuthor.rows || isAuthor.rows.length <= 0) {
			return (result = {
				message: 'Category not found :D',
				code: 400,
				data: null,
			});
		}

		const query: OracleDB.Result<ICategory> = await connection.execute(
			`BEGIN
				link_book_category(:p_book_id, :p_category_id);
            END;`,
			{
				p_book_id: { val: book_id, type: OracleDB.DB_TYPE_NVARCHAR },
				p_category_id: {
					val: category_id,
					type: OracleDB.DB_TYPE_NVARCHAR,
				},
			}
		);

		return (result = {
			code: 200,
			message: 'Category add to book',
		});
	};

	updateCategory = async (
		id: string,
		name: string
	): Promise<IError<ICategory>> => {
		let result: IError<ICategory>;

		const connection = await Database.getConnection();

		await connection.execute(
			`BEGIN
				update_category(:p_category_id, :p_name);
			END;`,
			{
				p_category_id: id,
				p_name: name,
			}
		);

		return (result = {
			message: 'Категория обновлена',
			code: 200,
			data: null,
		});
	};
}

export default CategoryService;
