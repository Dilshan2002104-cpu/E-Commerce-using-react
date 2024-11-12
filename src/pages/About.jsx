import React from 'react'
import Title from '../components/Title'
import { assets } from '../assets/assets'
import NewLetterBox from '../components/NewLetterBox'

const About = () => {
  return (
    <div>
      <div className='text-2xl text-center pt-8 border-t'>
        <Title text1={'ABOUT'} text2={'US'}/>
      </div>
      <div className='my-10 flex flex-col md:flex-row gap-16'>
        <img className='w-full md:max-w-[480px]' src={assets.about_img} alt="" />
        <div className='flex flex-col justify-center gap-6 md:w-2/4 text-gray-600'>
          <p>Lorem ipsum dolor sit amet consectetur adipisicing elit. Voluptatum incidunt, ipsum aspernatur commodi debitis neque illum dolores facere possimus deleniti voluptas earum nobis corrupti deserunt velit ipsam tempora asperiores totam?</p>
          <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Recusandae sunt nam perferendis veniam officiis, laborum beatae doloribus dolorem, molestias fuga explicabo non exercitationem qui ab animi temporibus, inventore sed officia.</p>
          <b className='text-gray-800'>Our Mission</b>
          <p>Lorem ipsum dolor sit amet consectetur, adipisicing elit. Laboriosam minima minus, hic animi molestiae dicta exercitationem recusandae quibusdam quisquam, facilis dolore aliquam excepturi omnis. Voluptatibus eos est nobis voluptate beatae.</p>
        </div>
      </div>
      <div className='text-4xl py-4'>
        <Title text1={'WHY'} text2={' CHOOSE US'}/>
      </div >
      <div className='flex flex-col md:flex-row text-sm mb-20'>
        <div className='border px-10 md:px-16 py-8 sm:py-20 flex flex-col gap-5'>
          <b>Quaility Assurance:</b>
          <p className='text-gray-600'>Lorem ipsum dolor sit amet consectetur adipisicing elit. Laborum maxime aut sequi fugiat quasi. Nihil autem atque temporibus labore repudiandae, dignissimos minima voluptatem quasi excepturi, voluptates ad molestias incidunt alias.</p>
        </div>
        <div className='border px-10 md:px-16 py-8 sm:py-20 flex flex-col gap-5'>
          <b>Convenience:</b>
          <p className='text-gray-600'>Lorem ipsum dolor sit amet consectetur adipisicing elit. Laborum maxime aut sequi fugiat quasi. Nihil autem atque temporibus labore repudiandae, dignissimos minima voluptatem quasi excepturi, voluptates ad molestias incidunt alias.</p>
        </div>
        <div className='border px-10 md:px-16 py-8 sm:py-20 flex flex-col gap-5'>
          <b>Exceptional Customer Service:</b>
          <p className='text-gray-600'>Lorem ipsum dolor sit amet consectetur adipisicing elit. Laborum maxime aut sequi fugiat quasi. Nihil autem atque temporibus labore repudiandae, dignissimos minima voluptatem quasi excepturi, voluptates ad molestias incidunt alias.</p>
        </div>
      </div>
      <NewLetterBox/>
    </div>
  )
}

export default About