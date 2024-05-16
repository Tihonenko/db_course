import { Button, Input, Select } from "antd";
import "../../App.scss";
import BookList from "../../components/book-list/book-list";
import BookAdd from "../../components/form/book-add";
import { useState } from "react";
import OrderAdd from "../../components/form/order-add";
import AuthorList from "../../components/author-list/author-list";
import AuthorAdd from "../../components/form/author-add";
import BookAuthor from "../../components/form/book-author";
import CategoryList from "../../components/category-list/category-list";
import CategoryAdd from "../../components/form/category-add";
import BookCategory from "../../components/form/book-category";
import UserList from "../../components/user-list/users-list";

const Admin = () => {
	const [selectForm, setSelectForm] = useState<string>("add-book");
	const [selectList, setSelectList] = useState<string>("book");

	const renderForm = () => {
		switch (selectForm) {
			case "add-book":
				return <BookAdd />;
			case "add-order":
				return <OrderAdd />;
			case "add-author":
				return <AuthorAdd />;
			case "book-author":
				return <BookAuthor />;
			case "add-category":
				return <CategoryAdd />;
			case "book-category":
				return <BookCategory />;
			default:
				return null;
		}
	};

	const renderList = () => {
		if (selectList === "author") {
			return <AuthorList />;
		} else if (selectList === "book") {
			return <BookList />;
		} else if (selectList === "category") {
			return <CategoryList />;
		} else if (selectList === "users") {
			return <UserList />;
		} else {
			return null;
		}
	};

	return (
		<section className='admin'>
			<div className='form'>
				<div>
					<div className='form_select'>
						<Button onClick={() => setSelectForm("add-book")}>Add book</Button>
						<Button onClick={() => setSelectForm("add-order")}>
							Add Order
						</Button>
						<Button onClick={() => setSelectForm("add-author")}>
							Add Author
						</Button>
						<Button onClick={() => setSelectForm("book-author")}>
							Link Book with author
						</Button>
						<Button onClick={() => setSelectForm("add-category")}>
							Add Category
						</Button>
						<Button onClick={() => setSelectForm("book-category")}>
							Link Book with category
						</Button>
					</div>
					{renderForm()}
				</div>
				<div></div>
			</div>
			<div style={{ width: "100%" }}>
				<div className='form_select'>
					<Button onClick={() => setSelectList("book")}>Book</Button>
					<Button onClick={() => setSelectList("author")}>Author</Button>
					<Button onClick={() => setSelectList("category")}>Category</Button>
					<Button onClick={() => setSelectList("users")}>Users</Button>
				</div>
				{renderList()}
			</div>
		</section>
	);
};

export default Admin;
