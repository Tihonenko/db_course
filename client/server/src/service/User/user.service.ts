import jwt from 'jsonwebtoken';
import Database from '@src/DB/DB';
import { IError } from '@src/dto/error.dto';
import { IUser, IUserCreate } from '@src/dto/user/user.dto';
import OracleDB from 'oracledb';
import { IFavorite } from '@src/dto/favorite/favorite.dto';
import { IBook } from '@src/dto/book/book.dto';

interface IOutUser {
	userId: string;
	role: string;
}

interface IRole {
	Name: string;
}

export class UserService {
	constructor() {}

	createUser = async (user: IUserCreate): Promise<IError<IUser>> => {
		let result: IError<IUser>;

		const connection = await Database.getConnection();

		const isLoginUsed = await connection.execute(
			`
            SELECT * FROM "User" WHERE login = :login
            `,
			[user.login],
			{
				outFormat: OracleDB.OUT_FORMAT_OBJECT,
			}
		);

		if (isLoginUsed && isLoginUsed.rows && isLoginUsed.rows.length > 0) {
			return (result = {
				message: 'This login was used',
				code: 400,
				data: null,
			});
		}

		const query = <OracleDB.Result<IOutUser>>await connection.execute(
			`BEGIN
              create_user(:p_login, :p_password, :p_name, :p_second_name, :p_email, :p_address, p_user_id => :userId, p_role_id => :role);
            END;`,
			{
				p_login: user.login,
				p_password: user.password,
				p_name: user.name,
				p_second_name: user.second_name,
				p_email: user.email,
				p_address: user.address,
				userId: { dir: OracleDB.BIND_OUT, type: OracleDB.STRING },
				role: { dir: OracleDB.BIND_OUT, type: OracleDB.STRING },
			}
		);

		const roleNameQ = <OracleDB.Result<IRole>>await connection.execute(
			`SELECT name FROM Role WHERE role_id = :role_id`,
			{
				role_id: {
					val: query.outBinds?.role,
				},
			},
			{
				outFormat: OracleDB.OUT_FORMAT_OBJECT,
			}
		);

		if (!roleNameQ.rows || roleNameQ.rows.length <= 0) {
			return (result = {
				message: 'Role not found, but user was created with role user',
				code: 400,
				data: null,
			});
		}

		const userId = query.outBinds?.userId;
		const role = roleNameQ.rows[0];
		const token = jwt.sign(
			{ userId, login: user.login, role },
			'your_secret_key',
			{
				expiresIn: '7d',
			}
		);

		const resUser = {
			token,
			name: user.name,
			login: user.login,
		};

		return (result = {
			message: 'User created',
			code: 200,
			data: resUser,
		});
	};

	getAllUsers = async (): Promise<IError<IUser>> => {
		let result: IError<IUser>;

		const connection = await Database.getConnection();

		const query: OracleDB.Result<IUser> = await connection.execute(
			`SELECT * from TABLE(get_all_users_info_view())`,
			{},
			{ outFormat: OracleDB.OUT_FORMAT_OBJECT }
		);

		if (!query.rows || query.rows.length <= 0) {
			return (result = {
				message: 'All users',
				code: 400,
				data: query.rows,
			});
		}

		return (result = {
			message: 'all users',
			code: 200,
			data: query.rows,
		});
	};

	deleteUser = async (id: string): Promise<IError<IUser>> => {
		let result: IError<IUser>;

		const connection = await Database.getConnection();

		const query: OracleDB.Result<IUser> = await connection.execute(
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

	login = async (login: string, password: string): Promise<IError<IUser>> => {
		let result: IError<IUser>;

		const connection = await Database.getConnection();

		const isLogin = <OracleDB.Result<IUser>>await connection.execute(
			`
			    SELECT * FROM "User" WHERE login = :login
			`,
			[login],
			{
				outFormat: OracleDB.OUT_FORMAT_OBJECT,
			}
		);

		if (!isLogin.rows || isLogin.rows.length <= 0) {
			return (result = {
				message: 'Login or password not valid :D',
				code: 400,
				data: null,
			});
		}

		const query: OracleDB.Result<IUser> = await connection.execute(
			`
			BEGIN
				authenticate_user(:p_login, :p_password, :isAuth);
            END;`,
			{
				p_login: { val: login, type: OracleDB.DB_TYPE_NVARCHAR },
				p_password: { val: password, type: OracleDB.DB_TYPE_NVARCHAR },
				isAuth: {
					dir: OracleDB.BIND_OUT,
					type: OracleDB.DB_TYPE_BOOLEAN,
				},
			}
		);

		if (!query.outBinds?.isAuth) {
			return (result = {
				message: 'Login or password not valid :D',
				code: 400,
				data: null,
			});
		}

		const roleId = isLogin.rows[0].ROLE_ID;

		const roleNameQ = <OracleDB.Result<IRole>>await connection.execute(
			`SELECT name FROM Role WHERE role_id = :role_id`,
			{
				role_id: {
					val: roleId,
				},
			},
			{
				outFormat: OracleDB.OUT_FORMAT_OBJECT,
			}
		);

		if (!roleNameQ.rows || roleNameQ.rows.length <= 0) {
			return (result = {
				message: 'Email or password not valid',
				code: 400,
				data: null,
			});
		}

		const userId = isLogin.rows[0].USER_ID;
		const role = roleNameQ.rows[0];
		const token = jwt.sign({ userId, login, role }, 'your_secret_key', {
			expiresIn: '7d',
		});

		const resUser = {
			token,
			login,
		};

		return (result = {
			code: 200,
			message: 'Hello',
			data: resUser,
		});
	};

	addFavorite = async (favorite: IFavorite) => {
		let result: IError<IFavorite>;

		const connection = await Database.getConnection();

		const query: OracleDB.Result<IFavorite> = await connection.execute(
			`BEGIN
                add_favorite_book(:p_book_id, :p_user_id);
         END;`,
			{
				p_book_id: {
					val: favorite.BOOK_ID,
					type: OracleDB.DB_TYPE_NVARCHAR,
				},
				p_user_id: {
					val: favorite.USER_ID,
					type: OracleDB.DB_TYPE_NVARCHAR,
				},
			}
		);

		return (result = {
			code: 200,
			message: 'Book add to favorite',
			data: null,
		});
	};

	deleteFavorite = async (
		favorite: IFavorite
	): Promise<IError<IFavorite>> => {
		let result: IError<IFavorite>;

		const connection = await Database.getConnection();

		const query: OracleDB.Result<IFavorite> = await connection.execute(
			`BEGIN
               delete_favorites(:p_book_id, :p_user_id);
         END;`,
			{
				p_book_id: {
					val: favorite.BOOK_ID,
					type: OracleDB.DB_TYPE_NVARCHAR,
				},
				p_user_id: {
					val: favorite.USER_ID,
					type: OracleDB.DB_TYPE_NVARCHAR,
				},
			}
		);

		return (result = {
			code: 200,
			message: 'Favorite book removed',
			data: null,
		});
	};

	getFavorite = async (favorite: IFavorite): Promise<IError<IBook>> => {
		let result: IError<IBook>;

		const connection = await Database.getConnection();

		const query: OracleDB.Result<IBook> = await connection.execute(
			`SELECT * FROM TABLE(get_favorite_books_by_user(:p_user_id))`,
			{
				p_user_id: {
					val: favorite.USER_ID,
				},
			},
			{
				outFormat: OracleDB.OUT_FORMAT_OBJECT,
			}
		);

		return (result = {
			code: 200,
			message: 'Your favorite book',
			data: query.rows,
		});
	};
}
export default UserService;
