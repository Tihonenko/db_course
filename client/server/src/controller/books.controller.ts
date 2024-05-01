import Database from "@src/DB/DB";
import { IBook } from "@src/dto/book/book.dto";
import BookService from "@src/service/Book/book.service";
import { Request, Response } from "express";

type fileType = Express.Multer.File | undefined;
type fileNameType = string | undefined;

class BookController {
	private _service: BookService;

	constructor(service: BookService) {
		this._service = service;
	}

	createBook = async (req: Request, res: Response) => {
		try {
			const {
				title,
				description,
				publication_date,
				publisher_name,
				isbn,
				tags,
				num_pages,
				copies,
			} = req.body;

			const files = req.files as { [fieldname: string]: Express.Multer.File[] };

			if (!files["cover"] || !files["pdf"]) {
				return res.status(400).json({
					message: "Файл обязателен",
				});
			}

			const cover: fileType = files["cover"][0];
			const pdf: fileType = files["pdf"][0];

			const coverName: fileNameType = cover.filename;
			const pdfName: fileNameType = pdf.filename;

			const Book: IBook = {
				title,
				description,
				publication_date,
				publisher_name,
				isbn,
				tags,
				num_pages,
				copies,
				coverName,
				pdfName,
			};

			const result = await this._service.createBook(Book);
			return res.status(result.code).json({
				code: result.code,
				message: result.message,
				data: result.data,
			});
		} catch (err) {
			console.log(err);
			return res.status(500).json({ message: "Ошибка сервера" });
		}
	};

	searchBook = async (req: Request, res: Response) => {
		try {
			const searchTerms = req.query.searchTerms as string;

			const result = await this._service.searchBook(searchTerms);

			return res.status(result.code).json({
				code: result.code,
				message: result.message,
				data: result.data,
			});
		} catch (err) {
			console.log(err);
			res.status(500).json({
				message: "Ошибка сервера",
			});
		}
	};

	getBookById = async (req: Request, res: Response) => {
		try {
			const { id } = req.params;

			const result = await this._service.getBookById(id);

			return res.status(result.code).json({
				code: result.code,
				message: result.message,
				data: result.data,
			});
		} catch (err) {
			console.log(err);
			res.status(500).json({
				message: "Ошибка сервера",
			});
		}
	};

	getBookByAuthor = async (req: Request, res: Response) => {
		try {
			const { id } = req.params;
			let { page, size } = req.query;

			if (!page) {
				page = "1";
			}

			if (!size) {
				size = "10";
			}

			if (isNaN(Number(page)) || isNaN(Number(size))) {
				return res.status(400).json({
					code: 400,
					message: "Параметры пагинации (page и size) должны быть числами",
				});
			}
			const result = await this._service.getBookByAuthor(
				id,
				Number(page),
				Number(size)
			);

			return res.status(result.code).json({
				code: result.code,
				message: result.message,
				data: result.data,
			});
		} catch (err) {
			console.log(err);
			res.status(500).json({
				message: "Ошибка сервера",
			});
		}
	};

	getBookByCategory = async (req: Request, res: Response) => {
		try {
			const { id } = req.params;
			let { page, size } = req.query;
			if (!page) {
				page = "1";
			}

			if (!size) {
				size = "10";
			}

			if (isNaN(Number(page)) || isNaN(Number(size))) {
				return res.status(400).json({
					code: 400,
					message: "Параметры пагинации (page и size) должны быть числами",
				});
			}
			const result = await this._service.getBookByCategory(
				id,
				Number(page),
				Number(size)
			);

			return res.status(result.code).json({
				code: result.code,
				message: result.message,
				data: result.data,
			});
		} catch (err) {
			console.log(err);
			res.status(500).json({
				message: "Ошибка сервера",
			});
		}
	};

	getBookByPublisher = async (req: Request, res: Response) => {
		try {
			const { id } = req.params;
			let { page, size } = req.query;

			if (!page) {
				page = "1";
			}

			if (!size) {
				size = "10";
			}

			if (isNaN(Number(page)) || isNaN(Number(size))) {
				return res.status(400).json({
					code: 400,
					message: "Параметры пагинации (page и size) должны быть числами",
				});
			}

			const result = await this._service.getBookByPublisher(
				id,
				Number(page),
				Number(size)
			);

			return res.status(result.code).json({
				code: result.code,
				message: result.message,
				data: result.data,
			});
		} catch (err) {
			console.log(err);
			res.status(500).json({
				message: "Ошибка сервера",
			});
		}
	};

	getAllBooks = async (req: Request, res: Response) => {
		try {
			let { page, size } = req.query;

			if (!page) {
				page = "1";
			}

			if (!size) {
				size = "10";
			}

			if (isNaN(Number(page)) || isNaN(Number(size))) {
				return res.status(400).json({
					code: 400,
					message: "Параметры пагинации (page и size) должны быть числами",
				});
			}

			const result = await this._service.getAllBooks(
				Number(page),
				Number(size)
			);

			return res.status(result.code).json({
				code: result.code,
				message: result.message,
				data: result.data,
			});
		} catch (err) {
			console.log(err);
			res.status(500).json({
				message: "Ошибка сервера",
			});
		}
	};

	deleteBook = async (req: Request, res: Response) => {
		try {
			const { id } = req.params;

			const result = await this._service.deleteBook(id);

			return res.status(result.code).json({
				code: result.code,
				message: result.message,
				data: result.data,
			});
		} catch (err) {
			console.log(err);
			res.status(500).json({
				message: "Ошибка сервера",
			});
		}
	};

	updateBook = async (req: Request, res: Response) => {
		try {
			const {
				title,
				description,
				publication_date,
				publisher_name,
				isbn,
				tags,
				num_pages,
				copies,
			} = req.body;

			console.log(req.body);

			const { id } = req.params;

			const files = req.files as { [fieldname: string]: Express.Multer.File[] };

			let cover: fileType;
			let pdf: fileType;
			let coverName: fileNameType;
			let pdfName: fileNameType;
			if (files && (files["cover"] || files["pdf"])) {
				const cover = files["cover"] ? files["cover"][0] : undefined;
				const pdf = files["pdf"] ? files["pdf"][0] : undefined;

				if (cover) {
					coverName = cover.filename;
				}
				if (pdf) {
					pdfName = pdf.filename;
				}
			}

			const book: IBook = {
				title,
				description,
				publication_date,
				publisher_name,
				isbn,
				tags,
				num_pages,
				copies,
				coverName,
				pdfName,
			};

			const result = await this._service.updateBook(id, book);
			return res.status(result.code).json({
				code: result.code,
				message: result.message,
				data: result.data,
			});
		} catch (err) {
			console.log(err);
			res.status(500).json({
				message: "Ошибка сервера",
			});
		}
	};
}

export default BookController;
