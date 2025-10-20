const CICDBanner = () => {
  return (
    <div className="border border-gray-400 bg-gray-50 py-8 px-4 mb-8">
      <div className="container mx-auto text-center">
        <div className="flex items-center justify-center gap-2 mb-4">
          <div className="w-8 h-[2px] bg-[#414141]"></div>
          <h2 className="text-xl md:text-2xl font-medium text-[#414141] prata-regular">
            Automated Deployment Active
          </h2>
          <div className="w-8 h-[2px] bg-[#414141]"></div>
        </div>
        <p className="text-gray-600 mb-6 text-sm md:text-base">
          This application is continuously deployed using modern DevOps practices
        </p>
        <div className="flex flex-wrap justify-center gap-3 text-sm">
          <span className="border border-gray-300 bg-white px-3 py-1 text-gray-700 font-medium">
            AUTOMATED TESTING
          </span>
          <span className="border border-gray-300 bg-white px-3 py-1 text-gray-700 font-medium">
            DOCKER BUILD
          </span>
          <span className="border border-gray-300 bg-white px-3 py-1 text-gray-700 font-medium">
            AWS EC2 DEPLOY
          </span>
          <span className="border border-gray-300 bg-white px-3 py-1 text-gray-700 font-medium">
            ZERO DOWNTIME
          </span>
        </div>
        <div className="flex items-center justify-center gap-2 mt-6">
          <p className="font-medium text-sm text-gray-700">LIVE DEPLOYMENT</p>
          <div className="w-8 h-[1px] bg-[#414141]"></div>
        </div>
      </div>
    </div>
  )
}

export default CICDBanner