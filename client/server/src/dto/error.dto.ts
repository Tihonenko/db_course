export interface IError<T> {
	message: string;
	code: number;
	data?: T[] | T | null;
}
