import { useEffect, useState } from 'react';
import styles from '../book-list/list.module.scss';
import { Button } from 'antd';
import { jwtDecode } from 'jwt-decode';
import { IFavorite } from './favorite.dto';
import { json } from 'react-router-dom';
import { format } from 'date-fns';

interface IRes {
	code?: number;
	data?: IFavorite[];
	message?: string;
}

const FavoriteList = () => {
	const [data, setData] = useState<IRes | null>();
	const [checkRole, setCheckRole] = useState('');

	const formattedDate = (item: IFavorite) => {
		const formattedDate = format(
			item.PUBLICATION_DATE,
			'dd-MMM-yyyy'
		).toUpperCase();
		return formattedDate;
	};

	const handleCopy = (value: string) => {
		navigator.clipboard.writeText(value);
		console.log('Copied to clipboard');
	};

	const getCategory = async () => {
		try {
			const token = localStorage.getItem('token');

			const decodedToken: {
				userId: string;
			} = jwtDecode(token);

			const id = decodedToken.userId;

			const response = await fetch(
				`http://localhost:8888/api/user/favorite/${id}`,
				{
					method: 'GET',
				}
			);

			if (!response.ok) {
				throw new Error('Res error');
			}

			const res: IRes = await response.json();
			setData(res);
		} catch (err) {
			console.log(err);
		}
	};

	const handleDelete = async (id: string) => {
		try {
			const token = localStorage.getItem('token');

			const decodedToken: {
				userId: string;
			} = jwtDecode(token);

			const userId = decodedToken.userId;

			const req = {
				book_id: id,
				user_id: userId,
			};

			const response = await fetch(
				`http://localhost:8888/api/user/remove-favorite`,
				{
					method: 'DELETE',
					headers: {
						'Content-Type': 'application/json',
					},
					body: JSON.stringify(req),
				}
			);

			if (!response.ok) {
				throw new Error('Res error');
			}

			const res: IRes = await response.json();
			setData(res);
		} catch (err) {
			console.log(err);
		}
	};

	useEffect(() => {
		const token = localStorage.getItem('token');

		const decodedToken: { role: { NAME: string } } = jwtDecode(token);

		const role = decodedToken.role;
		setCheckRole(role.NAME);
	}, []);

	return (
		<section className={styles.book_container}>
			<div>
				<div className={styles.book_list_buttons}>
					<div>Buttons</div>
					<div>
						<Button onClick={() => getCategory()}>
							Get Categories
						</Button>
					</div>
				</div>
				{data?.code === 400 ? <p>Ничего не найдено</p> : null}
				<p>{data?.message}</p>
				<div className={styles.book_list}>
					{data &&
						data?.data?.map((item, idx) => (
							<div className={styles.author_item} key={idx}>
								<div>
									<p>{item.BOOK_ID}</p>
									<div
										style={{ display: 'flex', gap: '20px' }}
									>
										<Button
											style={{ width: '30%' }}
											type='primary'
											onClick={() =>
												handleCopy(item.BOOK_ID)
											}
										>
											Copy ID
										</Button>
									</div>
								</div>
								<h3>{item.TITLE}</h3>
								<div className={styles.book_image}>
									<img
										alt='example'
										src={`http://localhost:8888/image/${item.IMAGE_NAME}`}
									/>
								</div>

								<h4>Title: {item.TITLE}</h4>
								<h4>ISB: {item.ISBN}</h4>
								<h4>Author: {item.AUTHOR_NAME}</h4>
								<h4>Category: {item.CATEGORY_NAME}</h4>
								<h4>Publication date: {formattedDate(item)}</h4>
								<h4>Num pages: {item.NUM_PAGES}</h4>
								<h4>Copies: {item.COPIES}</h4>
								<h4>Description: {item.DESCRIPTION}</h4>

								<Button
									onClick={() => handleDelete(item.BOOK_ID)}
								>
									Remove
								</Button>
							</div>
						))}
				</div>
			</div>
		</section>
	);
};

export default FavoriteList;
