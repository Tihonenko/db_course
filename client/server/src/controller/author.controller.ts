import Database from "@src/DB/DB";
import { Request, Response } from "express";
import OracleDB from "oracledb";

class AuthorController {
	async createAuthor(req: Request, res: Response) {
		const { name } = req.body;

		if (!name) {
			return res.status(400).json({ message: "Name is required" });
		}

		try {
			const connection = await Database.getConnection();
			const result = await connection.execute(
				`BEGIN
				   creat_author(:name);
				 END;`,
				{ name }
			);

			res.status(201).json({ message: "Author created successfully", result });
			console.log("Author created successfully", result);
		} catch (err) {
			console.log(" Error in createAuthor: ", err);
			return res.status(500).json({ message: "Internal server error" });
		}
	}
}

export default AuthorController;
