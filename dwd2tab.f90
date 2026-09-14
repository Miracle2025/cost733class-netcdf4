program main
  implicit none
  character(len=1000) :: filename,outfile
  character(len=8) :: date
  integer :: status,dummy
  integer :: year,month,day
  real(kind=8) :: temp,dampfdruck,bedeckung,druck,rhum, &
          & windgeschwindigkeit,tmax,tmin,tbodenmin,windmax,prec,precind,sdauer,schneehoehe

  call getarg(1,filename) 
  open(1,file=filename,status="old")
  outfile=filename(1:len_trim(filename)-4)//".temp.dat"
  open(2,file=outfile,status="replace")
  outfile=filename(1:len_trim(filename)-4)//".rhum.dat"
  open(3,file=outfile,status="replace")
  outfile=filename(1:len_trim(filename)-4)//".prec.dat"
  open(4,file=outfile,status="replace")
  outfile=filename(1:len_trim(filename)-4)//".wspd.dat"
  open(5,file=outfile,status="replace")

  read(1,*)
  do
     read(1,*,iostat=status)dummy,date,dummy,temp,dampfdruck,bedeckung,druck,rhum, &
          & windgeschwindigkeit,tmax,tmin,tbodenmin,windmax,prec,precind,sdauer,schneehoehe
     read(date,"(i4,2i2)")year,month,day
     if(status/=0)exit
     write(2,"(4i4,1f8.1)")year,month,day,12,temp
     write(3,"(4i4,1f8.1)")year,month,day,12,rhum
     write(4,"(4i4,1f8.1)")year,month,day,12,prec
     write(5,"(4i4,1f8.1)")year,month,day,12,windgeschwindigkeit
  enddo
  close(1)
  close(2)
  close(3)
  close(4)

end program main
