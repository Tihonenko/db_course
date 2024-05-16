import { Input, Select } from "antd";
import { useState } from "react";
import Button from "../UI/Button";

const { Option } = Select;

const OrderAdd = () => {
	const [userId, setUserId] = useState<string>("");
	const [bookId, setBookId] = useState<string>("");
	const [days, setDays] = useState<string>("");
	const [hours, setHours] = useState<string>("");
	const [minutes, setMinutes] = useState<string>("");
	const [status, setStatus] = useState<string>("");
	const handleSubmit = async (event: React.FormEvent<HTMLFormElement>) => {
		event.preventDefault();

		const req = {
			userId,
			bookId,
			days,
			hours,
			minutes,
			status,
		};

		try {
			const response = await fetch("http://localhost:8888/api/order/add", {
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
					<label htmlFor='userId'>
						User ID:
						<Input
							type='text'
							id='userId'
							name='userId'
							onChange={(e) => setUserId(e.target.value)}
						/>
					</label>
				</div>
				<div>
					<label htmlFor='bookId'>Book ID:</label>
					<Input
						type='text'
						id='bookId'
						name='bookId'
						onChange={(e) => setBookId(e.target.value)}
					/>
				</div>
				<div>
					<label htmlFor='days'>Days:</label>
					<Input
						type='number'
						id='days'
						name='days'
						onChange={(e) => setDays(e.target.value)}
					/>
				</div>
				<div>
					<label htmlFor='hours'>Hours:</label>
					<Input
						type='number'
						id='hoyrs'
						name='hours'
						onChange={(e) => setHours(e.target.value)}
					/>
				</div>
				<div>
					<label htmlFor='minutes'>Minutes:</label>
					<Input
						type='number'
						id='minutes'
						name='minutes'
						onChange={(e) => setMinutes(e.target.value)}
					/>
				</div>
				<div>
					<label htmlFor='status'>Status:</label>
					<Select
						id='status'
						onChange={(value) => setStatus(value)}
						defaultValue={status}
					>
						<Option value='Выдан'>Выдан</Option>
						<Option value='Завершен'>Завершен</Option>
						<Option value='В процессе'>В процессе</Option>
						<Option value='Отменен'>Отменен</Option>
					</Select>
				</div>
				<Button type='submit'>Create</Button>
			</form>
		</section>
	);
};

export default OrderAdd;
