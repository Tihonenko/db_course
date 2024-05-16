import { Button } from 'antd';
import { useState } from 'react';
import AuthorList from '../../components/author-list/author-list';
import BookList from '../../components/book-list/book-list';
import CategoryList from '../../components/category-list/category-list';
import FavoriteList from '../../components/favorite-list/favorite-list';

const List = () => {
	const [selectList, setSelectList] = useState<string>('book');

	const renderList = () => {
		if (selectList === 'author') {
			return <AuthorList />;
		} else if (selectList === 'book') {
			return <BookList />;
		} else if (selectList === 'category') {
			return <CategoryList />;
		} else if (selectList === 'order') {
			return;
		} else if (selectList === 'favorite') {
			return <FavoriteList />;
		} else {
			return null;
		}
	};
	return (
		<>
			<div className='form_select'>
				<Button onClick={() => setSelectList('book')}>Book</Button>
				<Button onClick={() => setSelectList('author')}>Author</Button>
				<Button onClick={() => setSelectList('category')}>
					Category
				</Button>
				<Button onClick={() => setSelectList('order')}>Order</Button>
				<Button onClick={() => setSelectList('favorite')}>
					Favorite
				</Button>
			</div>
			<div>{renderList()}</div>
		</>
	);
};

export default List;
