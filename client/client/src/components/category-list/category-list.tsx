import { useEffect, useState } from "react";
import styles from "../book-list/list.module.scss";
import { Button } from "antd";
import { ICategory } from "./category.dto";
import ModalCategory from "./modal-category";
import { jwtDecode } from "jwt-decode";

interface IRes {
	code?: number;
	data?: ICategory[];
	message?: string;
}

const CategoryList = () => {
	const [data, setData] = useState<IRes | null>();
	const [checkRole, setCheckRole] = useState("");

	const handleCopy = (value: string) => {
		navigator.clipboard.writeText(value);
		console.log("Copied to clipboard");
	};

	const getCategory = async () => {
		try {
			const response = await fetch(`http://localhost:8888/api/category`, {
				method: "GET",
			});

			if (!response.ok) {
				throw new Error("Res error");
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
				category_id: id,
			};

			console.log(id);

			const response = await fetch(`http://localhost:8888/api/category`, {
				method: "DELETE",
				headers: {
					"Content-Type": "application/json",
				},
				body: JSON.stringify(req),
			});

			if (!response.ok) {
				throw new Error("Res error");
			}

			const res: IRes = await response.json();
			setData(res);
		} catch (err) {
			console.log(err);
		}
	};

	useEffect(() => {
		const token = localStorage.getItem("token");

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
						<Button onClick={() => getCategory()}>Get Categories</Button>
					</div>
				</div>
				{data?.code === 400 ? <p>Ничего не найдено</p> : null}
				<p>{data?.message}</p>
				<div className={styles.book_list}>
					{data &&
						data?.data?.map((item, idx) => (
							<div className={styles.author_item} key={idx}>
								<div>
									<p>{item.CATEGORY_ID}</p>
									<div style={{ display: "flex", gap: "20px" }}>
										<Button
											style={{ width: "30%" }}
											type='primary'
											onClick={() => handleCopy(item.CATEGORY_ID)}
										>
											Copy ID
										</Button>
										{checkRole === "admin" || checkRole === "manager" ? (
											<ModalCategory category_id={item.CATEGORY_ID} />
										) : null}
									</div>
								</div>
								<h3>{item.NAME}</h3>

								{checkRole === "admin" || checkRole === "manager" ? (
									<Button onClick={() => handleDelete(item.CATEGORY_ID)}>
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

export default CategoryList;
