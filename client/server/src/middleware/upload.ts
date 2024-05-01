import { pathUploads } from "@src/app";
import multer from "multer";
import path from "path";

const storage = multer.diskStorage({
	destination: (req, file, cb) => {
		if (file.fieldname === "pdf") {
			cb(null, pathUploads + "/pdf/");
		}
		if (file.fieldname === "cover") {
			cb(null, pathUploads + "/image/");
		}
	},
	filename: (req, file, cb) => {
		if (file.fieldname === "pdf") {
			cb(null, file.fieldname + Date.now() + path.extname(file.originalname));
		}
		if (file.fieldname === "cover") {
			cb(null, file.fieldname + Date.now() + path.extname(file.originalname));
		}
	},
});

export const upload = multer({ storage: storage });

export default upload;
