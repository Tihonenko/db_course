import React, { useState } from 'react';
import { jwtDecode } from 'jwt-decode';
import { Input } from 'antd';
import Button from '../../../components/UI/Button';
import styles from '../home.module.scss';

import { Navigate } from 'react-router-dom';

interface IRole {
	NAME?: string;
}

const Login = () => {
	const [checkRole, setCheckRole] = useState('');

	const [login, setLogin] = useState<string>('');
	const [password, setPassword] = useState<string>('');
	const [error, setError] = useState<string | null>(null);

	const handleSubmit = async (event: React.FormEvent<HTMLFormElement>) => {
		event.preventDefault();

		try {
			const response = await fetch(
				'http://localhost:8888/api/user/login',
				{
					method: 'POST',
					headers: {
						'Content-Type': 'application/json',
					},
					body: JSON.stringify({
						login,
						password,
					}),
				}
			);

			if (!response.ok) {
				throw new Error('Server Error');
			}

			const { data } = await response.json();
			console.log(data);
			const token = data.token;
			localStorage.setItem('token', token);

			console.log(jwtDecode(token));
			const decodedToken: { role: IRole } = jwtDecode(token);

			const role = decodedToken.role;

			if (role.NAME === 'user') {
				setCheckRole('user');
			} else if (role.NAME === 'admin') {
				setCheckRole('admin');
			}
		} catch (error) {
			setError(error.message);
			console.error(error);
		}
	};

	if (checkRole === 'user') {
		return <Navigate to='/user' />;
	}

	if (checkRole === 'manager') {
		return <Navigate to='/admin' />;
	}

	if (checkRole === 'admin') {
		return <Navigate to='/admin' />;
	}

	return (
		<form className={styles.form} onSubmit={handleSubmit}>
			<div>
				<label htmlFor='login'>Login</label>
				<Input
					type='text'
					id='login'
					placeholder='Логин'
					value={login}
					onChange={(e) => setLogin(e.target.value)}
				/>
			</div>
			<div>
				<label htmlFor='Password'>Password</label>

				<Input
					id='password'
					type='password'
					placeholder='Пароль'
					value={password}
					onChange={(e) => setPassword(e.target.value)}
				/>
			</div>
			<Button type='submit'>Registration</Button>
			{error && <div>{error}</div>}
		</form>
	);
};

export default Login;
