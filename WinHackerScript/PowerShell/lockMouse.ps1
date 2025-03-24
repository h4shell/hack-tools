
while ($true) {
	Add-Type -MemberDefinition '[DllImport("user32")] public static extern bool SetCursorPos(int x, int y);' -Name U32 -Namespace W;
	[W.U32]::SetCursorPos(0, 0)
}
