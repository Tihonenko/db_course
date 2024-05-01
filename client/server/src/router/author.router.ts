import { Router } from "express";
import AuthorController from "@src/controller/author.controller";
import Database from "@src/DB/DB";

const authorController = new AuthorController();

const router = Router();

router.post("/author", authorController.createAuthor);

// get by author, category, publisher book in books.router.ts

export default router;
