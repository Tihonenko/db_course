import styles from "./button.module.scss";

const Button = (props) => {
	const { children, type } = props;

	return (
		<button className={styles.btn_send} type={type} {...props}>
			{children}
		</button>
	);
};

export default Button;
