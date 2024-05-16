import { useState } from "react";
import styles from "./home.module.scss";
import Register from "./register/Register";
import { Button } from "antd";
import Login from "./Login/Login";

const Home = () => {
	const [selectForm, setSelectForm] = useState<string>("register");

	const renderForm = () => {
		if (selectForm === "register") {
			return <Register />;
		} else if (selectForm === "login") {
			return <Login />;
		} else {
			return null;
		}
	};

	return (
		<section className={styles.home}>
			<div className={styles.container_form}>
				<div className={styles.form_button}>
					<Button onClick={() => setSelectForm("register")}>Register</Button>
					<Button onClick={() => setSelectForm("login")}>Login</Button>
				</div>
				{renderForm()}
			</div>
		</section>
	);
};

export default Home;
