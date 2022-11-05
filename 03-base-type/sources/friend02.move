module sender::friend02 {
    use sender::friend01;
    fun x(){
        friend01::add(1,2);
    }
}


