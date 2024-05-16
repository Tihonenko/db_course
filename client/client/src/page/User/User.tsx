import { useEffect, useState } from 'react';
import List from './List';
import { jwtDecode } from 'jwt-decode';
import { Navigate } from 'react-router-dom';
import { Button } from 'antd';

const User = () => {
	const [checkRole, setCheckRole] = useState('');
	const [id, setId] = useState('');
	const [isLoggedIn, setIsLoggedIn] = useState(true);

	useEffect(() => {
		try {
			const token = localStorage.getItem('token');

			if (!token) {
				setIsLoggedIn(false);
				return;
			}

			const decodedToken: {
				role: { NAME: string };
				userId: string;
			} = jwtDecode(token);

			const id = decodedToken.userId;

			const role = decodedToken.role;
			setCheckRole(role.NAME);
			setId(id);
		} catch (err) {
			console.error('Ошибка декодирования токена:', err);
		}
	}, []);

	const handleLogout = () => {
		localStorage.removeItem('token');
		setIsLoggedIn(false);
	};

	if (!isLoggedIn) {
		return <Navigate to='/' />;
	}

	return (
		<>
			<div>
				<h2>USER: {id}</h2>
				<Button onClick={handleLogout}>Logout</Button>
			</div>
			<section></section>
			<section>
				<List />
			</section>
		</>
	);
};

export default User;
