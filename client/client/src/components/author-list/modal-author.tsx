import { Button, DatePicker, Input, Modal } from "antd";
import React, { FC, useState } from "react";

interface IModalProps {
	author_id: string;
}

const ModalAuthor: FC<IModalProps> = ({ author_id }) => {
	const [isModalOpen, setIsModalOpen] = useState(false);

	const [name, setName] = useState<string>("");

	const showModal = () => {
		setIsModalOpen(true);
	};

	const handleOk = () => {
		setIsModalOpen(false);
	};

	const handleCancel = () => {
		setIsModalOpen(false);
	};

	const handleSubmit = async (
		event: React.FormEvent<HTMLFormElement>,
		id: string
	) => {
		event.preventDefault();

		const res = {
			name: name,
			author_id: author_id,
		};

		try {
			const response = await fetch(
				`http://localhost:8888/api/author/update/${id}`,
				{
					headers: {
						"Content-Type": "application/json",
					},
					method: "PATCH",
					body: JSON.stringify(res),
				}
			);
			if (!response.ok) {
				throw new Error("Network response was not ok");
			}
		} catch (error) {
			console.error(error);
		}

		handleOk();
	};

	return (
		<>
			<Button type='primary' onClick={showModal}>
				Edit Author
			</Button>
			<Modal
				title='Basic Modal'
				open={isModalOpen}
				onOk={handleOk}
				onCancel={handleCancel}
			>
				<form
					className='book_add_form'
					onSubmit={(event) => handleSubmit(event, author_id)}
				>
					<div>
						<label htmlFor='name'>
							Name Category:
							<Input
								type='text'
								id='name'
								name='name'
								onChange={(e) => setName(e.target.value)}
							/>
						</label>
					</div>

					<Button htmlType='submit'>Create</Button>
				</form>
			</Modal>
		</>
	);
};

export default ModalAuthor;
