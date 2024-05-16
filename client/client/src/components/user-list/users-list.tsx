import { useState } from 'react';
import styles from '../book-list/list.module.scss';
import { Button } from 'antd';
import { IUser } from './user.dto';

interface IRes {
	code?: number;
	data?: IUser[];
	message?: string;
}

const UserList = () => {
	const [data, setData] = useState<IRes | null>();

	const handleCopy = (value: string) => {
		navigator.clipboard.writeText(value);
		console.log('Copied to clipboard');
	};

	const getCategory = async () => {
		try {
			const response = await fetch(`http://localhost:8888/api/user/all`, {
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

	return (
		<section className={styles.book_container}>
			<div>
				<div className={styles.book_list_buttons}>
					<div>Buttons</div>
					<div>
						<Button onClick={() => getCategory()}>Get Users</Button>
					</div>
				</div>
				{data?.code === 400 ? <p>Ничего не найдено</p> : null}
				<p>{data?.message}</p>
				<div className={styles.book_list}>
					{data &&
						data?.data?.map((item, idx) => (
							<div className={styles.author_item} key={idx}>
								<div>
									<p>{item.USER_ID}</p>
									<Button
										style={{ width: '30%' }}
										type='primary'
										onClick={() => handleCopy(item.USER_ID)}
									>
										Copy ID
									</Button>
								</div>
								<h3>Login: {item.LOGIN}</h3>
								<h3>Name: {item.NAME}</h3>
								<h3>Second name: {item.SECOND_NAME}</h3>
								<h3>Email: {item.EMAIL}</h3>
								<h3>Address: {item.ADDRESS}</h3>
								<p>Role id: {item.ROLE_ID}</p>
							</div>
						))}
				</div>
			</div>
		</section>
	);
};

export default UserList;
