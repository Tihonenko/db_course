import { Router } from "express";
import OrderService from "@src/service/Order/order.service";
import OrderController from "@src/controller/order.controller";
import upload from "@src/middleware/upload";

const orderService = new OrderService();
const orderController = new OrderController(orderService);

const router = Router();

router.post("/order/add", orderController.createOrder);

export default router;
