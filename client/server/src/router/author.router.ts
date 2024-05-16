import { Router } from "express";
import AuthorController from "@src/controller/author.controller";
import AuthorService from "@src/service/Author/author.service";

const authorService = new AuthorService();
const authorController = new AuthorController(authorService);

const router = Router();

router.post("/author", authorController.createAuthor);
router.get("/author", authorController.getAuthors);

router.delete("/author", authorController.deleteAuthor);
router.post("/author-book", authorController.authorBook);

router.patch("/author/update/:id", authorController.updateAuthor);
// get by author, category, publisher book in books.router.ts

export default router;
