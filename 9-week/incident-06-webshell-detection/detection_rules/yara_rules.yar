rule WebShell_Detection
{
    strings:
        $a = "system($_GET"
    condition:
        $a
}
