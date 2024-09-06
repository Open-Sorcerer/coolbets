const Spinner = ({
  size = "md",
  color = "blew",
}: {
  size?: "sm" | "md" | "lg";
  color?: "blew" | "white";
}) => {
  const sizeClasses = {
    sm: "border-2 h-4 w-4",
    md: "border-4 h-8 w-8",
    lg: "border-4 h-10 w-10",
  };

  const colorClasses = {
    blew: "border-blew",
    white: "border-white",
  };

  return (
    <div
      className={`mx-auto inline-block animate-spin rounded-full border-solid border-e-transparent align-[-0.125em] text-surface motion-reduce:animate-[spin_1.5s_linear_infinite] dark:text-blew-500 ${sizeClasses[size]} ${colorClasses[color]}`}
      role="status"
    >
      <span className="!absolute !-m-px !h-px !w-px !overflow-hidden !whitespace-nowrap !border-0 !p-0 ![clip:rect(0,0,0,0)]">
        Loading...
      </span>
    </div>
  );
};

export default Spinner;
