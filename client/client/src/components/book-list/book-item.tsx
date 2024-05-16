import { Button } from 'antd';
import { IBook } from './book.dto';
import styles from './list.module.scss';
import { format } from 'date-fns';
import ModalBook from './modal-book';
import { useEffect, useState } from 'react';
import { jwtDecode } from 'jwt-decode';

interface IBookItem {
	book: IBook;
}

interface IRes {
	code?: number;
	data?: IBook[];
	message?: string;
}

const BookItem: React.FC<IBookItem> = ({ book }) => {
	const [checkRole, setCheckRole] = useState('');
	const [id, setId] = useState('');

	const formattedDate = format(
		book.PUBLICATION_DATE,
		'dd-MMM-yyyy'
	).toUpperCase();

	const handleCopy = (value: string) => {
		navigator.clipboard.writeText(value);
		console.log('Copied to clipboard');
	};

	useEffect(() => {
		const token = localStorage.getItem('token');

		const decodedToken: { role: { NAME: string }; userId: string } =
			jwtDecode(token);

		const role = decodedToken.role;
		const id = decodedToken.userId;
		setCheckRole(role.NAME);
		setId(id);
	}, []);

	const handleDelete = async (id: string) => {
		try {
			const response = await fetch(
				`http://localhost:8888/api/book/delete/${id}`,
				{
					method: 'DELETE',
				}
			);

			if (!response.ok) {
				throw new Error('Res error');
			}
		} catch (err) {
			console.log(err);
		}
	};

	const handleAddFavorite = async (book_id: string) => {
		try {
			const req = {
				book_id,
				user_id: id,
			};

			const response = await fetch(
				`http://localhost:8888/api/user/add-favorite`,
				{
					method: 'POST',
					headers: {
						'Content-Type': 'application/json',
					},
					body: JSON.stringify(req),
				}
			);
		} catch (err) {
			console.log(err);
		}
	};

	return (
		<div className={styles.book_item}>
			<div className={styles.book_item_data}>
				<div className={styles.book_item_data_id}>
					<p>{book.BOOK_ID}</p>
					<div className={styles.btn_book_item}>
						<Button
							style={{ width: '30%' }}
							type='primary'
							onClick={() => handleCopy(book.BOOK_ID)}
						>
							Copy ID
						</Button>
						{checkRole === 'admin' || checkRole === 'manager' ? (
							<ModalBook book_id={book.BOOK_ID} />
						) : null}
					</div>
				</div>
				<div className={styles.book_image}>
					<img
						alt='example'
						src={`http://localhost:8888/image/${book.IMAGE_NAME}`}
					/>
				</div>

				<h4>Title: {book.TITLE}</h4>
				<h4>ISB: {book.ISBN}</h4>
				<h4>Author: {book.AUTHOR_NAME}</h4>
				<h4>Category: {book.CATEGORY_NAME}</h4>
				<h4>Publication date: {formattedDate}</h4>
				<h4>Num pages: {book.NUM_PAGES}</h4>
				<h4>Copies: {book.COPIES}</h4>
				<h4>Description: {book.DESCRIPTION}</h4>
				{checkRole === 'admin' ? (
					<Button onClick={() => handleDelete(book.BOOK_ID)}>
						DELETE
					</Button>
				) : (
					<Button onClick={() => handleAddFavorite(book.BOOK_ID)}>
						Add favorite
					</Button>
				)}
			</div>
		</div>
	);
};

export default BookItem;
