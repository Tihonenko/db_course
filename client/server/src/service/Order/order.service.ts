import Database from "@src/DB/DB";
import { IError } from "@src/dto/error.dto";
import { IOrder } from "@src/dto/order/order.dto";
import Email from "@src/email/Email";
import OracleDB from "oracledb";

export class OrderService {
	constructor() {}

	createBook = async (order: IOrder): Promise<IError<IOrder>> => {
		let result: IError<IOrder>;

		const email = new Email();

		const connection = await Database.getConnection();

		const query = <OracleDB.Result<IOrder>>await connection.execute(
			`
                DECLARE
    
                BEGIN
                    create_order_status(
                        :p_user_id,
                        :p_book_id,
                        :p_days,
                        :p_hours, 
                        :p_minutes, 
                        :p_status_name
                );
              END;`,
			{
				p_user_id: order.userId,
				p_book_id: order.bookId,
				p_days: order.days,
				p_hours: order.hours,
				p_minutes: order.minutes,
				p_status_name: order.status,
			}
		);

		await email.sendEmail(
			`Создан заказ ${order.status} ${order.bookId}`,
			"Создание заказа"
		);

		return (result = {
			code: 200,
			message: "Заказ добавлен",
		});
	};
}

export default OrderService;
