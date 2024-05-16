import { IFavorite } from '@src/dto/favorite/favorite.dto';
import { IUserCreate } from '@src/dto/user/user.dto';
import Email from '@src/email/Email';
import UserService from '@src/service/User/user.service';
import { Request, Response } from 'express';

class UserController {
	_service: UserService;
	private _email: Email;

	constructor(service: UserService) {
		this._service = service;
		this._email = new Email();
	}

	createUser = async (req: Request, res: Response) => {
		try {
			const { login, password, name, secondName, email, address } =
				req.body;

			const user: IUserCreate = {
				login,
				password,
				name,
				second_name: secondName,
				email,
				address,
			};

			const result = await this._service.createUser(user);

			if (result.code === 200) {
				this._email.sendEmailYandex(
					'был зарегистрирован новый пользователь',
					'новый USER в базе данных'
				);
			}

			return res.status(result.code).json({
				code: result.code,
				message: result.message,
				data: result.data,
			});
		} catch (err) {
			console.error(err);
			res.status(500).json({ message: 'Ошибка создания пользователя' });
		}
	};

	getAllUsers = async (req: Request, res: Response) => {
		try {
			const result = await this._service.getAllUsers();

			return res.status(result.code).json({
				code: result.code,
				message: result.message,
				data: result.data,
			});
		} catch (err) {
			console.error(err);
			res.status(500).json({ message: 'Server error' });
		}
	};

	login = async (req: Request, res: Response) => {
		try {
			const { login, password } = req.body;

			const result = await this._service.login(login, password);

			return res.status(result.code).json({
				code: result.code,
				message: result.message,
				data: result.data,
			});
		} catch (err) {
			console.error(err);
			res.status(500).json({ message: 'Server error' });
		}
	};

	addFavorite = async (req: Request, res: Response) => {
		try {
			const { book_id, user_id } = req.body;

			const favorite: IFavorite = {
				BOOK_ID: book_id,
				USER_ID: user_id,
			};

			const result = await this._service.addFavorite(favorite);

			if (result.code === 200) {
				this._email.sendEmailYandex(
					'Была дабавлена какая-то книга в favorite',
					'новая favorite книга у пользователя'
				);
			}

			return res.status(result.code).json({
				code: result.code,
				message: result.message,
				data: result.data,
			});
		} catch (err) {
			console.log(err);
			res.status(500).json({ message: 'Server error' });
		}
	};

	deleteFavorite = async (req: Request, res: Response) => {
		try {
			const { book_id, user_id } = req.body;

			const favorite: IFavorite = {
				BOOK_ID: book_id,
				USER_ID: user_id,
			};

			const result = await this._service.deleteFavorite(favorite);

			if (result.code === 200) {
				this._email.sendEmailYandex(
					'Была удалена какая-то книга в favorite',
					'удалена favorite книга у пользователя'
				);
			}

			return res.status(result.code).json({
				code: result.code,
				message: result.message,
				data: result.data,
			});
		} catch (err) {
			console.log(err);
			res.status(500).json({ message: 'Server error' });
		}
	};

	getFavorite = async (req: Request, res: Response) => {
		try {
			const { id } = req.params;

			const favorite: IFavorite = {
				USER_ID: id,
			};

			const result = await this._service.getFavorite(favorite);

			return res.status(result.code).json({
				code: result.code,
				message: result.message,
				data: result.data,
			});
		} catch (err) {
			console.log(err);
			res.status(500).json({ message: 'Server error' });
		}
	};
}

export default UserController;
