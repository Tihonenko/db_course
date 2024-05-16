import { IOrder, orderStatus } from "@src/dto/order/order.dto";
import OrderService from "@src/service/Order/order.service";
import { Request, Response } from "express";

export class OrderController {
	private _service: OrderService;

	constructor(service: OrderService) {
		this._service = service;
	}

	createOrder = async (req: Request, res: Response) => {
		try {
			const { userId, bookId, days, hours, minutes, status } = req.body;
			if (!Object.values(orderStatus).includes(status)) {
				return res.status(400).json({ message: "Неверный статус заказа" });
			}

			const order: IOrder = {
				userId,
				bookId,
				days: Number(days),
				hours: Number(hours),
				minutes: Number(minutes),
				status,
			};
			const result = await this._service.createBook(order);

			return res.status(result.code).json({
				code: result.code,
				message: result.message,
				data: result.data,
			});
		} catch (err) {
			console.log(err);
			res.status(500).json({ message: Error });
		}
	};
}

export default OrderController;
