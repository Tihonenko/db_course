import { Router } from "express";
import AuthorController from "@src/controller/author.controller";
import UserController from "@src/controller/user.controller";

const userController = new UserController();

const router = Router();

router.post("/user", userController.createUser);

export default router;
