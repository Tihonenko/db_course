import { Router } from "express";
import CategoryService from "@src/service/Category/category.service";
import CategoryController from "@src/controller/category.controller";

const categoryService = new CategoryService();
const categoryController = new CategoryController(categoryService);

const router = Router();

router.post("/category", categoryController.createCategory);
router.get("/category", categoryController.getCategories);

router.delete("/category", categoryController.deleteCategories);
router.post("/category-book", categoryController.categoryBook);

router.patch("/category/update/:id", categoryController.updateCategory);
// get by author, category, publisher book in books.router.ts

export default router;
