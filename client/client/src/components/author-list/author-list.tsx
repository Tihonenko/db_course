import { useEffect, useState } from 'react';
import styles from '../book-list/list.module.scss';
import { IAuthor } from './author.dto';
import { Button } from 'antd';
import ModalAuthor from './modal-author';
import { jwtDecode } from 'jwt-decode';

interface IRes {
	code?: number;
	data?: IAuthor[];
	message?: string;
}

const AuthorList = () => {
	const [data, setData] = useState<IRes | null>();
	const [checkRole, setCheckRole] = useState('');

	const handleCopy = (value: string) => {
		navigator.clipboard.writeText(value);
		console.log('Copied to clipboard');
	};

	useEffect(() => {
		const token = localStorage.getItem('token');

		const decodedToken: { role: { NAME: string } } = jwtDecode(token);

		const role = decodedToken.role;

		setCheckRole(role.NAME);
	}, []);

	const getAuthor = async () => {
		try {
			const response = await fetch(`http://localhost:8888/api/author`, {
				method: 'GET',
			});

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
			const req = {
				author_id: id,
			};

			const response = await fetch(`http://localhost:8888/api/author`, {
				method: 'DELETE',
				headers: {
					'Content-Type': 'application/json',
				},
				body: JSON.stringify(req),
			});

			if (!response.ok) {
				throw new Error('Res error');
			}

			const res: IRes = await response.json();
			setData(res);
		} catch (err) {
			console.log(err);
		}
	};

	return (
		<section className={styles.book_container}>
			<div>
				<div className={styles.book_list_buttons}>
					<div>Buttons</div>
					<div>
						<Button onClick={() => getAuthor()}>Get Authors</Button>
					</div>
				</div>
				{data?.code === 400 ? <p>Ничего не найдено</p> : null}
				<p>{data?.message}</p>
				<div className={styles.book_list}>
					{data &&
						data?.data?.map((item, idx) => (
							<div className={styles.author_item} key={idx}>
								<div>
									<p>{item.AUTHOR_ID}</p>
									<div
										style={{ display: 'flex', gap: '20px' }}
									>
										<Button
											style={{ width: '30%' }}
											type='primary'
											onClick={() =>
												handleCopy(item.AUTHOR_ID)
											}
										>
											Copy
										</Button>
										{checkRole === 'admin' ||
										checkRole === 'manager' ? (
											<ModalAuthor
												author_id={item.AUTHOR_ID}
											/>
										) : null}
									</div>
								</div>
								<h3>{item.NAME}</h3>

								{checkRole === 'admin' ? (
									<Button
										onClick={() =>
											handleDelete(item.AUTHOR_ID)
										}
									>
										DELETE
									</Button>
								) : null}
							</div>
						))}
				</div>
			</div>
		</section>
	);
};

export default AuthorList;
