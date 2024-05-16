import { Router } from 'express';
import UserController from '@src/controller/user.controller';
import UserService from '@src/service/User/user.service';

const userService = new UserService();
const userController = new UserController(userService);

const router = Router();

router.post('/user', userController.createUser);
router.get('/user/all', userController.getAllUsers);
router.post('/user/login', userController.login);
router.post('/user/add-favorite', userController.addFavorite);
router.get('/user/favorite/:id', userController.getFavorite);
router.delete('/user/remove-favorite', userController.deleteFavorite);

export default router;
