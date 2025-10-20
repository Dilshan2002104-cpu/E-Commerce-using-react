const VersionFooter = () => {
  const version = "v1.1.0"
  
  return (
    <div className="border-t border-gray-400 bg-gray-50 py-3 px-4 text-center text-sm mt-8">
      <div className="container mx-auto flex flex-col sm:flex-row justify-between items-center gap-2">
        <span className="text-gray-600 font-medium">
          E-Commerce App {version} | Deployed via CI/CD Pipeline
        </span>
        <span className="text-gray-500 text-xs">
          Last Deploy: {new Date().toLocaleDateString()}
        </span>
      </div>
    </div>
  )
}

export default VersionFooter