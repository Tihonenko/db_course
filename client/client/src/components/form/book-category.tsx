import { Input } from "antd";
import React, { useState } from "react";
import Button from "../UI/Button";

const BookCategory = () => {
	const [bookId, setBookId] = useState<string>("");
	const [categoryId, setCategoryId] = useState<string>("");

	const handleSubmit = async (event: React.FormEvent<HTMLFormElement>) => {
		event.preventDefault();

		const req = {
			book_id: bookId,
			category_id: categoryId,
		};

		try {
			const response = await fetch("http://localhost:8888/api/category-book", {
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
					<label htmlFor='categoryId'>
						Category id:
						<Input
							type='text'
							id='categoryId'
							name='categoryId'
							onChange={(e) => setCategoryId(e.target.value)}
						/>
					</label>
				</div>
				<Button type='submit'>Create</Button>
			</form>
		</section>
	);
};

export default BookCategory;
