import Database from "@src/DB/DB";
import { Request, Response } from "express";
import jwt from "jsonwebtoken";
import OracleDB from "oracledb";

class UserController {
	async createUser(req: Request, res: Response) {
		const { login, password, name, secondName, email, address } = req.body;
		const connection = await Database.getConnection();

		const isLoginUsed = await connection.execute(
			`
            SELECT * FROM "User" WHERE login = :login
            `,
			[login],
			{
				outFormat: OracleDB.OUT_FORMAT_OBJECT,
			}
		);

		if (isLoginUsed && isLoginUsed.rows && isLoginUsed.rows.length > 0) {
			return res
				.status(409)
				.json({ message: "Пользователь с таким логином уже существует" });
		}

		try {
			const result = await connection.execute(
				`BEGIN
              create_user(:login, :password, :name, :secondName, :email, :address, p_user_id => :userId);
            END;`,
				{
					login,
					password,
					name,
					secondName,
					email,
					address,
					userId: { dir: OracleDB.BIND_OUT, type: OracleDB.STRING },
				}
			);

			const userId = result.outBinds;

			const token = jwt.sign({ userId, login }, "your_secret_key", {
				expiresIn: "7d",
			});

			res.status(201).json({ message: "Пользователь создан", token });
		} catch (err) {
			console.error(err);
			res.status(500).json({ message: "Ошибка создания пользователя" });
		}
	}
}

export default UserController;
