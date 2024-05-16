import { IAuthor } from '@src/dto/author/author.dto';
import Email from '@src/email/Email';
import AuthorService from '@src/service/Author/author.service';
import { Request, Response } from 'express';

class AuthorController {
	private _service: AuthorService;
	private _email: Email;
	constructor(service: AuthorService) {
		this._service = service;
		this._email = new Email();
	}

	createAuthor = async (req: Request, res: Response) => {
		try {
			const { name } = req.body;

			if (!name) {
				return res.status(400).json({ message: 'Name is required' });
			}

			const Author: IAuthor = {
				name,
			};

			const result = await this._service.createAuthor(Author);

			if (result.code === 200) {
				this._email.sendEmailYandex(
					`была создана новый автор ${Author.name}`,
					'новые данные в таблице Author'
				);
			}

			return res.status(result.code).json({
				code: result.code,
				message: result.message,
				data: result.data,
			});
		} catch (err) {
			console.log(' Error in createAuthor: ', err);
			return res.status(500).json({ message: 'Internal server error' });
		}
	};

	getAuthors = async (req: Request, res: Response) => {
		const result = await this._service.getAllAuthors();

		return res
			.status(result.code)
			.json({ code: result.code, message: 'Авторы', data: result.data });
	};

	deleteAuthor = async (req: Request, res: Response) => {
		try {
			const { author_id } = req.body;

			const result = await this._service.deleteAuthor(author_id);

			return res.status(result.code).json({
				code: result.code,
				message: result.message,
				data: result.data,
			});
		} catch (err) {
			console.log(err);
			res.status(500).json({
				message: 'Ошибка сервера',
			});
		}
	};

	authorBook = async (req: Request, res: Response) => {
		try {
			const { author_id, book_id } = req.body;

			const result = await this._service.authorBook(book_id, author_id);

			if (result.code === 200) {
				this._email.sendEmailYandex(
					`была удален автор`,
					'новые данные в таблице Author'
				);
			}

			return res.status(result.code).json({
				code: result.code,
				message: result.message,
				data: result.data,
			});
		} catch (err) {
			console.log(err);
			res.status(500).json({
				message: 'Ошибка сервера',
			});
		}
	};

	updateAuthor = async (req: Request, res: Response) => {
		try {
			const { name, author_id } = req.body;

			const result = await this._service.updateAuthor(author_id, name);

			if (result.code === 200) {
				this._email.sendEmailYandex(
					`была обновлен автор ${name}`,
					'новые данные в таблице Author'
				);
			}

			return res.status(result.code).json({
				code: result.code,
				message: result.message,
				data: result.data,
			});
		} catch (err) {
			console.log(err);
			res.status(500).json({
				message: 'Ошибка сервера',
			});
		}
	};
}

export default AuthorController;
