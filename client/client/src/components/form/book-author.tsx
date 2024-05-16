import { Input } from "antd";
import React, { useState } from "react";
import Button from "../UI/Button";

const BookAuthor = () => {
	const [bookId, setBookId] = useState<string>("");
	const [authorId, setAuthorId] = useState<string>("");

	const handleSubmit = async (event: React.FormEvent<HTMLFormElement>) => {
		event.preventDefault();

		const req = {
			book_id: bookId,
			author_id: authorId,
		};

		try {
			const response = await fetch("http://localhost:8888/api/author-book", {
				method: "POST",
				headers: {
					"Content-Type": "application/json",
				},
				body: JSON.stringify(req),
			});

			if (!response.ok) {
				throw new Error("Network response was not ok");
			}
		} catch (error) {
			console.error(error);
		}
	};

	return (
		<section className='order_add'>
			<form className='order_add' onSubmit={handleSubmit}>
				<div>
					<label htmlFor='bookId'>
						Book id:
						<Input
							type='text'
							id='bookId'
							name='bookId'
							onChange={(e) => setBookId(e.target.value)}
						/>
					</label>
				</div>
				<div>
					<label htmlFor='authorId'>
						Author id:
						<Input
							type='text'
							id='authorId'
							name='authorId'
							onChange={(e) => setAuthorId(e.target.value)}
						/>
					</label>
				</div>
				<Button type='submit'>Create</Button>
			</form>
		</section>
	);
};

export default BookAuthor;
