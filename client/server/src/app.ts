import express, { Application, Request, Response } from "express";

import cors from "cors";
import authorRouter from "@src/router/author.router";
import userRouter from "@src/router/user.router";
import bookRouter from "@src/router/books.router";
import dotenv from "dotenv";
import OracleDB from "oracledb";
import multer from "multer";
import path from "path";
import * as bodyParser from "body-parser";
import upload from "./middleware/upload";

dotenv.config();

// Load environment variables from .env file

const PORT = process.env.PORT || 8000;

const app: Application = express();
app.use(
	cors({
		origin: "*",
		methods: ["GET", "POST", "PUT", "DELETE", "PATCH"],
	})
);
app.use(express.json());
app.use(express.static(__dirname + "/uploads"));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use("/api", authorRouter);
app.use("/api", userRouter);
app.use("/api", bookRouter);

export const pathUploads = __dirname + "/uploads";

app.post(
	"/",
	upload.fields([
		{ name: "cover", maxCount: 2 },
		{ name: "pdf", maxCount: 1 },
	]),

	async (req: Request, res: Response) => {
		console.log(req.files);
		console.log(req.body);
		res.send("Hello World!");
		res.status(200);
	}
);

async function start() {
	try {
		OracleDB.getConnection({
			user: "ADMIN_LIB_PDB",
			password: "1234",
			connectionString: "localhost:1521/pdb_lib",
		})
			.then((connection) => {
				console.log("OracleDB connected");
			})
			.catch((error) => {
				console.error("Error connecting to OracleDB:", error);
			});

		app.listen(PORT, () => console.log(`Server started on port: ${PORT}`));
	} catch (e) {
		console.log(e);
	}
}

start();
