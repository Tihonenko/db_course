import './App.scss';
import { Route, Routes } from 'react-router-dom';
import Admin from './page/Admin/admin';
import Home from './page/Home/Home';
import User from './page/User/User';

const App = () => {
	return (
		<main className='main'>
			<Routes>
				<Route path='/' element={<Home />} />
				<Route path='/user' element={<User />} />
				<Route path='/admin' element={<Admin />} />
			</Routes>
		</main>
	);
};

export default App;
