import dotenv from 'dotenv';
import * as nodemailer from 'nodemailer';

dotenv.config();
// load password from ENV
const YANDEX_PASS = process.env.YANDEX_EMAIL_PASSWORD;
const GMAIL_PASS = process.env.GMAIL_YANDEX_PASSWORD;

export class Email {
	constructor() {}

	sendEmail = async (message: string, subject: string) => {
		try {
			let transporter = nodemailer.createTransport({
				service: 'gmail',
				auth: {
					user: 'tihonenko.nikita.228@gmail.com',
					pass: GMAIL_PASS,
				},
			});

			let mailOptions = {
				from: 'tihonenko.nikita.228@gmail.com',
				to: 'nikireatz@gmail.com',
				subject: subject,
				text: message,
			};

			let info = await transporter.sendMail(mailOptions);
			console.log('Email sent: ', info.response);
		} catch (error) {
			console.error('Error sending email: ', error);
		}
	};

	sendEmailYandex = async (message: string, subject: string) => {
		try {
			let transporter = nodemailer.createTransport({
				service: 'yandex',
				auth: {
					user: 'tihon.24.06',
					pass: YANDEX_PASS,
				},
			});

			let mailOptions = {
				from: 'tihon.24.06@yandex.ru',
				to: 'nikireatz@gmail.com',
				subject: subject,
				text: message,
			};

			let info = await transporter.sendMail(mailOptions);
			console.log('Email sent: ', info.response);
		} catch (error) {
			console.error('Error sending email: ', error);
		}
	};
}

export default Email;

//vjrkjdqljuonjhum
