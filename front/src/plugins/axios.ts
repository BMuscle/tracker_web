import axios from 'axios'

export default axios.create({
  baseURL: process.env.VUE_APP_BACK_END_API_URL,
  headers: {
    'X-Requested-With': 'XMLHttpRequest'
  },
  withCredentials: true
})
