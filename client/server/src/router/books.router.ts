import { Router } from "express";
import BooksController from "@controller/books.controller";
import upload from "@src/middleware/upload";
import BookService from "@service/Book/book.service";
import BookController from "@controller/books.controller";

const bookService = new BookService();
const booksController = new BooksController(bookService);

const router = Router();

router.post(
	"/book",
	upload.fields([
		{ name: "cover", maxCount: 1 },
		{ name: "pdf", maxCount: 1 },
	]),
	booksController.createBook
);
router.get("/book/search", booksController.searchBook);
router.get("/book/:id", booksController.getBookById);
router.get("/books/all", booksController.getAllBooks);

router.patch(
	"/book/update/:id",
	upload.fields([
		{ name: "cover", maxCount: 1 },
		{ name: "pdf", maxCount: 1 },
	]),
	booksController.updateBook
);

router.delete("/book/delete/:id", booksController.deleteBook);

// get by author, category, publisher
router.get("/author/:id/book", booksController.getBookByAuthor);
router.get("/category/:id/book", booksController.getBookByCategory);
router.get("/publisher/:id/book", booksController.getBookByPublisher);

export default router;
