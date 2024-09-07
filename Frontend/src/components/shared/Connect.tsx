import { ConnectKitButton } from "connectkit";
import styled from "styled-components";

const StyledButton = styled.button`
  cursor: pointer;
  position: relative;
  display: inline-block;
  padding: 6px 20px;
  color: #ffffff;
  background: #8b5cf6;
  font-size: 16px;
  font-weight: 500;
  border-radius: 10rem;

  transition: 200ms ease;
  &:hover {
    box-shadow: 0 4px 24px -6px #8b5cf6;
  }
  &:active {
    transform: translateY(-3px);
    box-shadow: 0 6px 32px -6px #8b5cf6;
  }
`;

export const ConnectButton = () => {
  return (
    <ConnectKitButton.Custom>
      {({ isConnected, show, truncatedAddress, ensName }) => {
        return (
          <StyledButton onClick={show}>
            {isConnected ? ensName ?? truncatedAddress : "Connect Wallet"}
          </StyledButton>
        );
      }}
    </ConnectKitButton.Custom>
  );
};
