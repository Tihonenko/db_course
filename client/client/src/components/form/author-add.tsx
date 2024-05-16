import { Input } from "antd";
import React, { useState } from "react";
import Button from "../UI/Button";

const AuthorAdd = () => {
	const [name, setName] = useState<string>("");

	const handleSubmit = async (event: React.FormEvent<HTMLFormElement>) => {
		event.preventDefault();

		const req = {
			name,
		};

		try {
			const response = await fetch("http://localhost:8888/api/author", {
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
					<label htmlFor='name'>
						Name:
						<Input
							type='text'
							id='name'
							name='name'
							onChange={(e) => setName(e.target.value)}
						/>
					</label>
				</div>
				<Button type='submit'>Create</Button>
			</form>
		</section>
	);
};

export default AuthorAdd;
