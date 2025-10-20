import Hero from '../components/Hero'
import LatestCollection from '../components/LatestCollection'
import BestSeller from '../components/BestSeller'
import OurPolicy from '../components/OurPolicy'
import NewLetterBox from '../components/NewLetterBox'
import CICDBanner from '../components/CICDBanner'


const Home = () => {
  return (
    <div>
      <Hero/>
      <CICDBanner/>
      <LatestCollection/>
      <BestSeller/>
      <OurPolicy/>
      <NewLetterBox/>
    </div>
  )
}

export default Home