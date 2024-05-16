import { Button, Input, Select } from "antd";
import { IBook } from "./book.dto";
import { useEffect, useState } from "react";
import BookItem from "./book-item";
import styles from "./list.module.scss";

const { Option } = Select;

interface IRes {
	code?: number;
	data?: IBook[];
	message?: string;
}

interface IListProps {}

const BookList: React.FC<IListProps> = () => {
	const [data, setData] = useState<IRes | null>();
	const [search, setSearch] = useState<string>("");
	const [params, setParams] = useState<string>("");
	const [get, setGet] = useState<string>("");

	const handleGetBooks = async () => {
		try {
			const response = await fetch(
				"http://localhost:8888/api/books/all?page=1&size=100",
				{
					method: "GET",
				}
			);

			if (!response.ok) {
				throw new Error("Network response was not ok");
			}

			const res: IRes = await response.json();
			setData(res);
			console.log("get", res);
		} catch (error) {
			console.error(error);
		}
	};

	const handleSearchBooks = async () => {
		try {
			const response = await fetch(
				`http://localhost:8888/api/book/search?searchTerms=${search}`
			);

			if (!response.ok) {
				throw new Error("Res error");
			}

			const res: IRes = await response.json();
			setData(res);

			console.log("search", data);
		} catch (err) {
			console.log(err);
		}
	};

	const getBy = async (params: string, get: string) => {
		try {
			const response = await fetch(
				`http://localhost:8888/api/${get}/${params}/book`
			);

			if (!response.ok) {
				throw new Error("Res error");
			}

			const res: IRes = await response.json();
			setData(res);

			console.log("search", data);
		} catch (err) {
			console.log(err);
		}
	};

	return (
		<section className={styles.book_container}>
			<div>
				<div className={styles.book_list_buttons}>
					<div>Buttons</div>
					<Button onClick={() => handleGetBooks()}>All boks</Button>
					<div className={styles.book_list_buttons_search}>
						<Input
							placeholder='Search Book/Author'
							onChange={(e) => setSearch(e.target.value)}
						/>
						<Button onClick={() => handleSearchBooks()}>Search</Button>
					</div>
					<div className={styles.book_list_buttons_search}>
						<Select
							id='status'
							onChange={(value) => setGet(value)}
							defaultValue={get}
							placeholder='Search to Select'
							style={{ width: 200 }}
						>
							<Option value='author'>Author</Option>
							<Option value='category'>Category</Option>
							<Option value='publisher'>Publisher</Option>
						</Select>
						<Input
							type='text'
							id='params'
							name='params'
							onChange={(e) => setParams(e.target.value)}
						/>
						<Button onClick={() => getBy(params, get)}>Get books</Button>
					</div>
				</div>
				{data?.code === 400 ? <p>Ничего не найдено</p> : null}
				<p>{data?.message}</p>
				<div className={styles.book_list}>
					{data &&
						data?.data?.map((item, idx) => <BookItem book={item} key={idx} />)}
				</div>
			</div>
		</section>
	);
};

export default BookList;
