import axios from 'axios'
import config from 'config'

export default axios.create({
  baseURL: config.back_end_api_url,
  headers: {
    'X-Requested-With': 'XMLHttpRequest'
  },
  withCredentials: true
})
