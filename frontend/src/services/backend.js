import axios from 'axios'

export default() => {
    // When running 'yarn serve', point our baseURL to the rails backend, hopefully running on 3000
    let url = ''
    if (process.env.NODE_ENV !== 'production') {
        url = 'http://localhost:3000'
    }

    return axios.create({
        baseURL: `${url}/`,
        withCredentials: false,
        headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
        }
    })
}