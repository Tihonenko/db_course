export interface IUser {
	user_id?: string;
	login?: string;
	role_id?: string;
	name?: string;
	second_name?: string;
	email?: string;
	address?: string;
	token?: string;
	ROLE_ID?: string;
	isAuth?: boolean;
	USER_ID?: string;
}

export interface IUserCreate {
	user_id?: string;
	login?: string;
	password: string;
	role_id?: string;
	name?: string;
	second_name?: string;
	email?: string;
	address?: string;
}
