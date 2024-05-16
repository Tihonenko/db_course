import Database from '@src/DB/DB';
import { IAuthor } from '@src/dto/author/author.dto';
import { ICategory } from '@src/dto/category/category.dto';
import { IError } from '@src/dto/error.dto';
import Email from '@src/email/Email';
import CategoryService from '@src/service/Category/category.service';
import { Request, Response } from 'express';
import OracleDB from 'oracledb';

class CategoryController {
	private _service: CategoryService;
	private _email: Email;

	constructor(service: CategoryService) {
		this._service = service;
		this._email = new Email();
	}

	createCategory = async (req: Request, res: Response) => {
		try {
			const { name } = req.body;

			if (!name) {
				return res.status(400).json({ message: 'Name is required' });
			}

			const category: ICategory = {
				name,
			};

			const result = await this._service.createCategory(category);

			if (result.code === 200) {
				this._email.sendEmailYandex(
					`была создана новая категория ${category.name}`,
					'новые данные в таблице Category'
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

	getCategories = async (req: Request, res: Response) => {
		try {
			const result = await this._service.getAllCategories();

			return res.status(result.code).json({
				code: result.code,
				message: result.message,
				data: result.data,
			});
		} catch (err) {
			res.status(500).json({
				message: 'Ошибка сервера',
			});
		}
	};

	deleteCategories = async (req: Request, res: Response) => {
		try {
			const { category_id } = req.body;

			const result = await this._service.deleteCategory(category_id);

			if (result.code === 200) {
				this._email.sendEmailYandex(
					`была удалена категория`,
					'новые данные в таблице Category'
				);
			}

			return res.status(result.code).json({
				code: result.code,
				message: result.message,
				data: result.data,
			});
		} catch (err) {
			res.status(500).json({
				message: 'Ошибка сервера',
			});
		}
	};

	categoryBook = async (req: Request, res: Response) => {
		try {
			const { category_id, book_id } = req.body;

			const result = await this._service.categoryBook(
				book_id,
				category_id
			);

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

	updateCategory = async (req: Request, res: Response) => {
		try {
			const { name, category_id } = req.body;

			const result = await this._service.updateCategory(
				category_id,
				name
			);

			if (result.code === 200) {
				this._email.sendEmailYandex(
					`была обновлена категория ${name}`,
					'новые данные в таблице Category'
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

export default CategoryController;
