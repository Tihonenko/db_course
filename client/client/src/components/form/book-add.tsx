import { useState } from "react";
import "../../App.scss";
import { Input, DatePicker } from "antd";
import Button from "../UI/Button";

const BookAdd = () => {
	const [coverFile, setCoverFile] = useState<File | string | null>(null);
	const [pdfFile, setPdfFile] = useState<File | string | null>(null);
	const [title, setTitle] = useState<string>("");
	const [isbn, setIsbn] = useState<string>("");
	const [description, setDescription] = useState<string>("");
	const [publication_date, setPublication_date] = useState<string>("");
	const [num_pages, setNum_pages] = useState<string>("");
	const [copies, setCopies] = useState<string>("");
	const [tags, setTags] = useState<string>("");

	const handleSubmit = async (event: React.FormEvent<HTMLFormElement>) => {
		event.preventDefault();
		const formData = new FormData();

		if (!coverFile) {
			formData.append("cover", "");
		} else {
			formData.append("cover", coverFile);
		}
		if (!pdfFile) {
			formData.append("pdf", "");
		} else {
			formData.append("pdf", pdfFile);
		}

		formData.append("title", title);
		formData.append("isbn", isbn);
		formData.append("description", description);
		formData.append("publication_date", publication_date);
		formData.append("num_pages", num_pages);
		formData.append("copies", copies);
		formData.append("tags", tags);

		try {
			const response = await fetch("http://localhost:8888/api/book/", {
				method: "POST",
				body: formData,
			});
			if (!response.ok) {
				throw new Error("Network response was not ok");
			}

			const data = await response.json();
			console.log(data);
		} catch (error) {
			console.error(error);
		}
	};
	return (
		<section className='book_add'>
			<form className='book_add_form' onSubmit={handleSubmit}>
				<div>
					<label htmlFor='title'>
						Title book:
						<Input
							type='text'
							id='title'
							name='title'
							onChange={(e) => setTitle(e.target.value)}
						/>
					</label>
				</div>
				<div>
					<label htmlFor='isbn'>ISBN book:</label>
					<Input
						type='text'
						id='isbn'
						name='isbn'
						onChange={(e) => setIsbn(e.target.value)}
					/>
				</div>
				<div>
					<label htmlFor='description'>Description book:</label>
					<Input.TextArea
						id='description'
						name='description'
						onChange={(e) => setDescription(e.target.value)}
					/>
				</div>
				<div>
					<label htmlFor='publication_date'>Publication date book:</label>
					<DatePicker
						type='date'
						id='publication_date'
						name='publication_date'
						placeholder='DD-MON-YYYY'
						format='DD-MON-YYYY'
						onChange={(date) => {
							if (date) {
								const formattedDate = date.format("DD-MMM-YYYY");
								setPublication_date(formattedDate);
							} else {
								setPublication_date("");
							}
						}}
					/>
				</div>
				<div>
					<label htmlFor='tags'>Tag book:</label>
					<Input
						type='text'
						id='tags'
						name='tags'
						onChange={(e) => setTags(e.target.value)}
					/>
				</div>
				<div>
					<label htmlFor='num_pages'>Pages number:</label>
					<Input
						type='number'
						id='num_pages'
						name='num_pages'
						onChange={(e) => setNum_pages(e.target.value)}
					/>
				</div>
				<div>
					<label htmlFor='copies'>Copiesbook:</label>
					<Input
						type='number'
						id='copies'
						name='copies'
						onChange={(e) => setCopies(e.target.value)}
					/>
				</div>

				<div>
					<label htmlFor='cover'>Cover Image:</label>
					<Input
						type='file'
						id='cover'
						name='cover'
						onChange={(e) => setCoverFile(e.target.files && e.target.files[0])}
					/>
				</div>
				<div>
					<label htmlFor='pdf'>PDF File:</label>
					<Input
						type='file'
						id='pdf'
						name='pdf'
						onChange={(e) => setPdfFile(e.target.files && e.target.files[0])}
					/>
				</div>
				<Button type='submit'>Create</Button>
			</form>
		</section>
	);
};

export default BookAdd;
